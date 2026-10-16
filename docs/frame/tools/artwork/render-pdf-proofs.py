from pathlib import Path
import re,subprocess,json
root=Path(__file__).resolve().parents[4]
source=root/'web/assets/selected-work/frame/source'
for p in [source/'frame-symbol.svg',source/'frame-symbol-mono.svg',source/'frame-app-icon.svg',source/'frame-wordmark-compact.svg']:
    p.write_text(re.sub(r'<defs>.*?</defs>','',p.read_text(),flags=re.S))
(root/'web/assets/selected-work/frame/frame-symbol.svg').write_text((source/'frame-symbol.svg').read_text())
for p in source.glob('*.pdf'):
    d=root/'docs/frame/verification/artwork/pdf-proofs'/p.stem
    d.mkdir(parents=True,exist_ok=True)
    subprocess.run(['/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/pdftoppm','-r','72','-png',str(p),str(d/'page')],check=True)
print('All 40 PDF pages rendered')

