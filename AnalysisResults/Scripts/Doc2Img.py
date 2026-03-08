from pathlib import Path
import sys
import markdown
from playwright.sync_api import sync_playwright


def md_to_longpng_batch(docs_dir: Path, imgs_dir: Path, width: int = 1200):
    docs_dir = docs_dir.resolve()
    imgs_dir = imgs_dir.resolve()
    imgs_dir.mkdir(parents=True, exist_ok=True)

    css = '''
    body{font-family: Arial, sans-serif; padding:20px; max-width:1000px; margin:auto; color:#222}
    pre{background:#2e2e2e;color:#f8f8f2;padding:10px;border-radius:6px;overflow:auto}
    img{max-width:100%;}
    '''

    md_files = sorted(docs_dir.glob('*.md'))
    if not md_files:
        print(f'No markdown files found in {docs_dir}')
        return

    with sync_playwright() as p:
        browser = p.chromium.launch()
        try:
            for md_path in md_files:
                try:
                    md_text = md_path.read_text(encoding='utf-8')
                    html = (
                        "<html><head><meta charset='utf-8'>"
                        f"<base href=\"{docs_dir.as_uri()}/\">"
                        f"<style>{css}</style></head>"
                        f"<body>{markdown.markdown(md_text, extensions=['fenced_code','codehilite'])}</body></html>"
                    )

                    tmp_html = imgs_dir / f"{md_path.stem}.html"
                    tmp_html.write_text(html, encoding='utf-8')

                    page = browser.new_page(viewport={"width": width, "height": 800})
                    page.goto(tmp_html.as_uri(), wait_until='networkidle')
                    out_png = imgs_dir / f"{md_path.stem}.png"
                    page.screenshot(path=str(out_png), full_page=True)
                    page.close()
                    try:
                        tmp_html.unlink()
                    except Exception:
                        pass
                    print(f'Rendered {md_path.name} -> {out_png.name}')
                except Exception as e:
                    print(f'Error rendering {md_path}: {e}', file=sys.stderr)
        finally:
            browser.close()


if __name__ == '__main__':
    script_dir = Path(__file__).resolve().parent
    docs_dir = (script_dir.parent / 'Docs')
    imgs_dir = (script_dir.parent / 'Imgs')

    if len(sys.argv) >= 3:
        docs_dir = Path(sys.argv[1])
        imgs_dir = Path(sys.argv[2])

    md_to_longpng_batch(docs_dir, imgs_dir)