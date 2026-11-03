"""Valida dois TXT realmente baixados do ADLS e os compara com a referência."""
import argparse
import csv
import hashlib
import json
from pathlib import Path


def validar(raw, copia, referencia):
    original = raw.read_bytes()
    redundante = copia.read_bytes()
    if not original or original != redundante:
        raise ValueError("As cópias estão vazias ou possuem bytes diferentes")
    with raw.open(encoding="utf-8-sig", newline="") as arquivo:
        registros = list(csv.DictReader(arquivo, delimiter=";"))
    with referencia.open(encoding="utf-8-sig", newline="") as arquivo:
        esperados = list(csv.DictReader(arquivo))
    ordenar = lambda linhas: sorted(linhas, key=lambda linha: int(linha["id_documento"]))
    if ordenar(registros) != ordenar(esperados):
        raise ValueError("O conteúdo exportado difere dos dados fictícios esperados")
    return {"resultado": "aprovado", "registros": len(registros),
            "quantidade_total": sum(int(r["quantidade"]) for r in registros),
            "bytes": len(original), "sha256": hashlib.sha256(original).hexdigest()}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("raw", type=Path)
    parser.add_argument("copia", type=Path)
    parser.add_argument("--referencia", type=Path,
                        default=Path(__file__).parent / "data/documentos_ficticios.csv")
    argumentos = parser.parse_args()
    print(json.dumps(validar(argumentos.raw, argumentos.copia, argumentos.referencia),
                     ensure_ascii=False, indent=2))
