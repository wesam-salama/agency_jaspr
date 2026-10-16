#!/usr/bin/env python3
"""Assemble a short, annotated edit of real browser and native recordings."""
from pathlib import Path
import json, subprocess, sys, hashlib

ROOT = Path(__file__).resolve().parents[3]
DOC = ROOT / 'docs/frame'
OUT = ROOT / 'web/assets/selected-work/frame'
FONT = OUT / 'fonts/space-grotesk-variable.ttf'

def probe(path):
    return json.loads(subprocess.check_output(['ffprobe','-v','quiet','-show_format','-show_streams','-of','json',str(path)]))

lang = sys.argv[1] if len(sys.argv) > 1 else 'en'
assert lang in {'en', 'ar'}
decision = json.loads((DOC / f'production/journey-edit-{lang}.json').read_text())
selected = int(sys.argv[2]) if len(sys.argv) > 2 else None
assert selected is None or 0 <= selected < len(decision['segments'])
work = DOC / 'production/recording-sources' / lang
work.mkdir(parents=True, exist_ok=True)
clips = []
for index, part in enumerate(decision['segments']):
    if selected is not None and index != selected:
        continue
    source = ROOT / part['source']
    info = probe(source)
    assert 0 <= part['start'] < part['end'] <= float(info['format']['duration']) + .05
    speed = part.get('speed', 1)
    title = work / f'{index:02}-title.txt'
    title.write_text(part['label'])
    header = work / 'header.txt'
    header.write_text(f'Frame Academy  /  {lang.upper()}  /  Studio concept')
    footer = work / f'{index:02}-footer.txt'
    footer.write_text(part.get('footnote', 'Actual implementation recording · local demonstration'))
    native = part['kind'] == 'native'
    scale = 'scale=470:1010:force_original_aspect_ratio=decrease' if native else 'scale=1780:920:force_original_aspect_ratio=decrease'
    placement = '1140:(1080-ih)/2' if native else '(1920-iw)/2:90'
    # Expand sparse simulator presentation frames to constant rate before trimming,
    # preserving their original on-screen hold times at each cut boundary.
    video_filter = (f'fps=25,trim=start={part["start"]}:end={part["end"]},setpts=(PTS-STARTPTS)/{speed},fps=25,{scale},'
                    f'pad=1920:1080:{placement}:color=0xF7F9FC,setsar=1,'
                    f'drawtext=fontfile={FONT}:textfile={header}:fontsize=32:fontcolor=0x244CCD:x=80:y=28,'
                    f'drawtext=fontfile={FONT}:textfile={title}:fontsize={62 if native else 28}:fontcolor=0x18243D:'
                    f'x=80:y={400 if native else 1030}:line_spacing=18,'
                    f'drawtext=fontfile={FONT}:textfile={footer}:fontsize=25:fontcolor=0x52627B:x=80:y={950 if native else 66}')
    clip = work / f'{index:02}.mp4'
    # Decode then trim by presentation timestamps: simulator media is variable-rate,
    # and input seeking can include pictures outside the intended source interval.
    subprocess.run(['ffmpeg','-hide_banner','-loglevel','error','-y','-i',str(source),'-an','-vf',video_filter,
                    '-c:v','libx264','-preset','fast','-crf','19','-pix_fmt','yuv420p',
                    '-colorspace','bt709','-color_primaries','bt709','-color_trc','bt709',
                    '-movflags','+faststart',str(clip)],check=True)
    clips.append(clip)

if selected is not None:
    clips = [work / f'{index:02}.mp4' for index in range(len(decision['segments']))]
    assert all(clip.is_file() for clip in clips), 'Build the complete edit before rebuilding one changed segment.'

concat = work / 'clips.txt'
concat.write_text(''.join("file '" + str(p).replace("'", "'\\''") + "'\n" for p in clips))
destination = OUT / ('demo-journey-ar.mp4' if lang == 'ar' else 'demo-journey.mp4')
subprocess.run(['ffmpeg','-hide_banner','-loglevel','error','-y','-f','concat','-safe','0','-i',str(concat),
                '-c','copy','-movflags','+faststart',str(destination)],check=True)
subprocess.run(['ffmpeg','-v','error','-i',str(destination),'-f','null','-'],check=True)
info = probe(destination)
record = {**decision, 'output':str(destination.relative_to(ROOT)), 'duration':float(info['format']['duration']),
          'dimensions':[1920,1080], 'fps':25, 'sha256':hashlib.sha256(destination.read_bytes()).hexdigest(),
          'editTruth':'Cuts and stated speed changes use actual video frames. No screenshot animation, generated UI, synthetic event or fabricated saved state.'}
(DOC / f'production/journey-record-{lang}.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'language':lang,'output':record['output'],'duration':record['duration'],'segments':len(clips)}))
