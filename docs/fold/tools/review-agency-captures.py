"""Build QA contact sheets from actual, unmodified agency browser captures."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageStat
import hashlib
import json

base = Path(__file__).resolve().parents[1] / 'verification/agency'
output = base / 'review'
output.mkdir(exist_ok=True)
records = []
for locale in ['en', 'ar', 'fr']:
    board = Image.new('RGB', (1150, 1920), '#eeeeee')
    draw = ImageDraw.Draw(board)
    for row, position in enumerate(['top', 'middle', 'end']):
        for x, width, target_width in [(10, 1440, 864), (902, 390, 234)]:
            name = f'{locale}-{width}-{position}.png'
            source = base / name
            with Image.open(source) as original:
                image = original.convert('RGB')
                image.load()
            assert image.size == (width, 1000), (name, image.size)
            extrema = image.getextrema()
            assert any(high > low for low, high in extrema), f'Flat/blank capture: {name}'
            records.append({'file': f'verification/agency/{name}', 'width': image.width, 'height': image.height, 'sha256': hashlib.sha256(source.read_bytes()).hexdigest(), 'pixelExtrema': extrema, 'pixelMean': ImageStat.Stat(image).mean})
            draw.text((x, row * 640 + 8), name, fill='black')
            image.thumbnail((target_width, 600))
            board.paste(image, (x, row * 640 + 30))
    board.save(output / f'{locale}-contact-sheet.png')
record = {'source': 'Unmodified screenshots captured by docs/fold/tools/check-agency.cjs from the compiled local agency', 'captureCount': len(records), 'expectedDimensionsAndNonblankCheck': 'passed', 'records': records, 'contactSheets': [f'verification/agency/review/{locale}-contact-sheet.png' for locale in ['en', 'ar', 'fr']], 'reviewScope': 'Contact sheets support capture validity and bounded desktop/mobile layout review; this is not a claim that eighteen independent full-resolution visual reviews were performed.'}
(base.parent / 'agency-capture-checks.json').write_text(json.dumps(record, indent=2) + '\n')
print(json.dumps({'captures': len(records), 'contactSheets': 3}))
