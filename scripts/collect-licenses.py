"""Preserve available license/notice files from the build's downloaded crates."""
from pathlib import Path
import os, shutil
cargo = Path(os.environ.get('CARGO_HOME', str(Path.home() / '.cargo')))
out = Path('licenses')
for crate in (cargo / 'registry' / 'src').glob('*/*'):
    for source in crate.rglob('*'):
        if not source.is_file() or source.is_symlink():
            continue
        name = source.name.upper()
        if not (name.startswith(('LICENSE', 'LICENCE', 'COPYING', 'NOTICE', 'COPYRIGHT')) or name == 'AUTHORS'):
            continue
        target = out / crate.name / source.relative_to(crate)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
