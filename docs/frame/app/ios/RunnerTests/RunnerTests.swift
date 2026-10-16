import XCTest

@MainActor
class RunnerTests: XCTestCase {
  func capture(_ name: String) {
    print("FRAME_CAPTURE \(name) UTC \(ISO8601DateFormatter().string(from: Date()))")
    let screen = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screen)
    attachment.name = name
    attachment.lifetime = .keepAlways
    add(attachment)
    do { try screen.pngRepresentation.write(to: URL(fileURLWithPath: "/tmp/frame-\(name).png")) }
    catch { print("PNG retained in xcresult attachment: \(name)") }
  }

  func makeVisible(_ element: XCUIElement, in app: XCUIApplication) {
    for _ in 0..<10 {
      if element.exists && element.isHittable && element.frame.minY >= app.frame.minY + 100 && element.frame.maxY <= app.frame.maxY - 40 { return }
      app.swipeUp()
    }
    XCTAssertTrue(element.exists && element.isHittable && element.frame.minY >= app.frame.minY + 100 && element.frame.maxY <= app.frame.maxY - 40)
  }
  func click(_ element: XCUIElement, in app: XCUIApplication) {
    let box = element.frame
    print("FRAME_NATIVE_TAP \(element.label) FRAME \(box)")
    app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
      .withOffset(CGVector(dx: box.midX - app.frame.minX, dy: box.midY - app.frame.minY)).tap()
  }
  func tap(_ label: String, in app: XCUIApplication) {
    let button = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", label)).firstMatch
    makeVisible(button, in: app)
    click(button, in: app)
  }
  func contains(_ text: String, in app: XCUIApplication) -> XCUIElement {
    app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
  }

  func acceptFrameScheme(arabic: Bool) throws {
    continueAfterFailure = false
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    let frame = XCUIApplication(bundleIdentifier: "media.cr8.frameAcademy")
    frame.terminate()
    XCTAssertEqual(frame.state, .notRunning)
    print("FRAME_HANDOFF_APP_STATE_BEFORE_REQUEST notRunning")
    safari.activate()
    print("FRAME_HANDOFF_READY UTC \(ISO8601DateFormatter().string(from: Date()))")
    capture("handoff-waiting")
    try Date().description.write(toFile: "/tmp/frame-handoff-ready", atomically: true, encoding: .utf8)
    let title = NSPredicate(format: "label CONTAINS %@ AND label CONTAINS %@", "Open", "Frame Academy")
    let systemTitle = springboard.descendants(matching: .any).matching(title).firstMatch
    let safariTitle = safari.descendants(matching: .any).matching(title).firstMatch
    let zero = arabic ? "اكتمل 0 من 6 دروس" : "0 of 6 lessons complete"
    let deadline = Date().addingTimeInterval(90)
    while !(systemTitle.exists && springboard.buttons["Open"].firstMatch.exists) && !(safariTitle.exists && safari.buttons["Open"].firstMatch.exists) && Date() < deadline {
      if frame.state == .runningForeground && contains(arabic ? "نظرة على الدورة" : "Course overview", in: frame).exists && contains("FA-PH-01", in: frame).exists { break }
      Thread.sleep(forTimeInterval: 0.5)
    }
    print("FRAME_SYSTEM_AX \(springboard.debugDescription)")
    print("FRAME_SAFARI_AX \(safari.debugDescription)")
    var accepted = 0
    for _ in 0..<8 {
      let systemOpen = springboard.buttons["Open"].firstMatch
      let safariOpen = safari.buttons["Open"].firstMatch
      if systemTitle.exists && systemOpen.exists {
        capture("handoff-os-confirmation")
        systemOpen.tap(); accepted += 1
      } else if safariTitle.exists && safariOpen.exists {
        capture("handoff-os-confirmation")
        safariOpen.tap(); accepted += 1
      } else { break }
    }
    print("FRAME_OS_CONFIRMATIONS_ACCEPTED \(accepted)")
    XCTAssertTrue(frame.wait(for: .runningForeground, timeout: 5))
    print("FRAME_HANDOFF_APP_STATE_AFTER_REQUEST runningForeground")
    XCTAssertTrue(contains(arabic ? "نظرة على الدورة" : "Course overview", in: frame).exists)
    XCTAssertTrue(contains("Composition Essentials", in: frame).waitForExistence(timeout: 8))
    XCTAssertTrue(contains("FA-PH-01", in: frame).exists)
    capture("course-overview-\(arabic ? "ar" : "en")")
    let prerequisite = contains(arabic ? "لا تحتاج إلى دورة سابقة." : "No prior course required.", in: frame)
    makeVisible(prerequisite, in: frame)
    XCTAssertTrue(prerequisite.exists)
    let equipment = contains(arabic ? "هاتف أو كاميرا، عنصر واحد والضوء المتاح." : "A phone or camera, one object and available light.", in: frame)
    makeVisible(equipment, in: frame)
    XCTAssertTrue(equipment.exists)
    let progress = contains(zero, in: frame)
    makeVisible(progress, in: frame)
    XCTAssertTrue(progress.exists)
    XCTAssertFalse(springboard.alerts.firstMatch.buttons["Open"].firstMatch.exists)
    capture("handoff-confirmed")
  }

  func testAcceptEnglishScheme() throws { try acceptFrameScheme(arabic: false) }
  func testAcceptArabicScheme() throws { try acceptFrameScheme(arabic: true) }

  func learningJourney(arabic: Bool) throws {
    let app = XCUIApplication(bundleIdentifier: "media.cr8.frameAcademy")
    app.activate()
    XCTAssertTrue(app.wait(for: .runningForeground, timeout: 8))
    let lang = arabic ? "ar" : "en"
    let zero = arabic ? "اكتمل 0 من 6 دروس" : "0 of 6 lessons complete"
    XCTAssertTrue(contains(zero, in: app).waitForExistence(timeout: 8))
    capture("course-zero-\(lang)")
    tap(arabic ? "تابع الدرس" : "Continue lesson", in: app)
    let play = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", arabic ? "شغّل الدرس" : "Play lesson")).firstMatch
    XCTAssertTrue(play.waitForExistence(timeout: 20))
    click(play, in: app)
    Thread.sleep(forTimeInterval: 4)
    capture("lesson-player-\(lang)")
    XCTAssertTrue(contains(arabic ? "30 ثانية" : "30 seconds", in: app).exists)
    tap(arabic ? "جرّب التمرين" : "Try the exercise", in: app)
    let field = app.textViews.firstMatch.exists ? app.textViews.firstMatch : app.textFields.firstMatch
    XCTAssertTrue(field.waitForExistence(timeout: 8))
    makeVisible(field, in: app); click(field, in: app)
    let note = arabic ? "عندما قرّبت العنصر من الحافة، أصبحت المساحة المجاورة أوضح. أبقيت الضوء نفسه في الصورتين." : "Moving the object toward the edge made the surrounding space more visible. I kept the light the same in both photographs."
    field.typeText(note)
    if app.keyboards.buttons["Done"].exists { app.keyboards.buttons["Done"].tap() }
    else if app.keyboards.buttons["تم"].exists { app.keyboards.buttons["تم"].tap() }
    tap(arabic ? "احفظ المسودة" : "Save draft", in: app)
    let failed = contains(arabic ? "تعذّر حفظ تقدّمك" : "We couldn’t save your progress", in: app)
    XCTAssertTrue(failed.waitForExistence(timeout: 8))
    XCTAssertTrue((field.value as? String)?.contains(arabic ? "المساحة المجاورة" : "surrounding space") == true)
    capture("exercise-failed-\(lang)")
    tap(arabic ? "أعد محاولة الحفظ" : "Retry save", in: app)
    XCTAssertTrue(contains(arabic ? "تم حفظ مسودة التمرين" : "Exercise draft saved", in: app).waitForExistence(timeout: 8))
    capture("exercise-saved-\(lang)")
    tap(arabic ? "أكمل التمرين" : "Mark exercise complete", in: app)
    let one = arabic ? "اكتمل 1 من 6 دروس" : "1 of 6 lessons complete"
    XCTAssertTrue(contains(one, in: app).waitForExistence(timeout: 8))
    capture("completed-\(lang)")
    app.terminate()
    app.launch()
    XCTAssertTrue(contains(one, in: app).waitForExistence(timeout: 12))
    XCTAssertTrue(contains(arabic ? "حدّد موضوع الصورة" : "Find the subject", in: app).exists)
    capture("restarted-next-\(lang)")
    tap(arabic ? "تابع الدرس" : "Continue lesson", in: app)
    XCTAssertTrue(contains(arabic ? "حدّد موضوع الصورة" : "Find the subject", in: app).waitForExistence(timeout: 8))
    XCTAssertTrue(contains(arabic ? "10 دقائق" : "10 minutes", in: app).exists)
    capture("lesson-02-\(lang)")
  }
  func testEnglishLearningJourney() throws { try learningJourney(arabic: false) }
  func testArabicLearningJourney() throws { try learningJourney(arabic: true) }
}
