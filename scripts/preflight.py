import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SHEETS = ("systems", "vehicles", "hooks")


def load_sheet(name):
    return json.loads((ROOT / f"sheets/{name}.json").read_text(encoding="utf-8"))


def flatten(value, prefix):
    if isinstance(value, dict):
        for key, child in value.items():
            yield from flatten(child, f"{prefix}.{key}")
    elif isinstance(value, list):
        if not value:
            yield prefix, value
        for index, child in enumerate(value):
            yield from flatten(child, f"{prefix}[{index}]")
    else:
        yield prefix, value


def main():
    sheets = {name: load_sheet(name) for name in SHEETS}
    checks = []
    ids = {}
    for name, rows in sheets.items():
        if not rows:
            checks.append((f"{name} rows", False, "sheet has no rows"))
        seen = set()
        for index, row in enumerate(rows):
            row_id = row.get("id")
            if not row_id:
                checks.append((f"{name}[{index}].id", False, "missing row identifier"))
                continue
            if row_id in seen:
                checks.append((f"{name}[{index}].id", False, f"duplicate id {row_id}"))
            seen.add(row_id)
            ids.setdefault(name, set()).add(row_id)
            for cell, value in flatten(row, f"{name}[{row_id}]"):
                filled = value is not None and value != "" and value != [] and value != {}
                checks.append((cell, filled, "filled" if filled else "empty cell"))

    systems = {row["id"]: row for row in sheets["systems"] if row.get("id")}
    valid_games = {"cyberpunk-2077", "gta-v"}
    for row in sheets["systems"]:
        for field in ("host_game", "companion_game"):
            game = row.get(field)
            ok = game in valid_games
            checks.append((f"systems[{row.get('id')}].{field} -> {game}", ok, "resolved game slug" if ok else "unknown game slug"))
    for row in sheets["hooks"]:
        ref = row.get("system_id")
        ok = ref in systems
        checks.append((f"hooks[{row.get('id')}].system_id -> {ref}", ok, "resolved" if ok else "unresolved reference"))
        rel = row.get("code_file", "")
        exists = (ROOT / rel).is_file()
        checks.append((f"hooks[{row.get('id')}].code_file -> {rel}", exists, "resolved file" if exists else "missing file"))
        event_ok = row.get("event") in {hook["event"] for hook in sheets["hooks"]}
        checks.append((f"hooks[{row.get('id')}].event -> {row.get('event')}", event_ok, "resolved hook event" if event_ok else "unknown hook event"))
    for row in sheets["systems"]:
        for field in ("generated_config", "codegen"):
            rel = row.get(field, "")
            path = ROOT / rel
            # The generated config is created by generate_config.py just before preflight.
            ok = path.is_file()
            checks.append((f"systems[{row.get('id')}].{field} -> {rel}", ok, "resolved file" if ok else "missing file"))
    for row in sheets["vehicles"]:
        game = row.get("game")
        checks.append((f"vehicles[{row.get('id')}].game -> {game}", game in valid_games, "resolved game slug" if game in valid_games else "unknown game slug"))
        rel = row.get("runtime_parser", "")
        path = ROOT / rel
        ok = path.is_file()
        checks.append((f"vehicles[{row.get('id')}].runtime_parser -> {rel}", ok, "resolved file" if ok else "missing file"))
        profile = row.get("profile_file")
        ok = profile == "profile.ini"
        checks.append((f"vehicles[{row.get('id')}].profile_file -> {profile}", ok, "resolved CET profile contract" if ok else "unexpected profile path"))
        config_rel = row.get("generated_config", "")
        config_ok = (ROOT / config_rel).is_file()
        checks.append((f"vehicles[{row.get('id')}].generated_config -> {config_rel}", config_ok, "resolved generated config" if config_ok else "missing generated config"))
        parser_text = path.read_text(encoding="utf-8") if path.is_file() else ""
        cet_file = ROOT / "src/CetMod/init.lua"
        cet_text = cet_file.read_text(encoding="utf-8") if cet_file.is_file() else ""
        for source_field in row.get("source_fields", []):
            mapped = row.get("profile_fields", {}).get(source_field)
            map_ok = mapped == source_field
            checks.append((f"vehicles[{row.get('id')}].profile_fields.{source_field} -> {mapped}", map_ok, "resolved field mapping" if map_ok else "missing or changed profile mapping"))
            parser_ok = f"('{source_field}='" in parser_text
            checks.append((f"vehicles[{row.get('id')}].runtime_parser includes {source_field}", parser_ok, "parser writes field" if parser_ok else "parser does not write field"))
            ui_ok = f"state.profile.{source_field}" in cet_text
            checks.append((f"vehicles[{row.get('id')}].CET panel reads {source_field}", ui_ok, "CET displays field" if ui_ok else "CET panel does not read field"))

    failures = [(label, detail) for label, ok, detail in checks if not ok]
    report = [
        "# Sheet preflight report",
        "",
        f"Result: **{'FAIL' if failures else 'PASS'}**",
        f"Checked {len(checks)} cells and references across {sum(len(rows) for rows in sheets.values())} rows in {len(sheets)} sheets.",
        "",
        "## Cell and reference audit",
        "",
        "| Check | Result | Detail |",
        "|---|---:|---|",
    ]
    for label, ok, detail in checks:
        safe_label = label.replace("|", "\\|")
        report.append(f"| `{safe_label}` | {'✓' if ok else '✗'} | {detail} |")
    report.extend(["", "## Unfilled cells and unresolved references", ""])
    if failures:
        report.extend(f"- `{label}`: {detail}" for label, detail in failures)
    else:
        report.append("None.")
    target = ROOT / "PRELIGHT_REPORT.md"
    target.write_text("\n".join(report) + "\n", encoding="utf-8")
    print("\n".join(report[:6]))
    print(f"Full report: {target}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

