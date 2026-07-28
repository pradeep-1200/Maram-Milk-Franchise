/**
 * Parses a human-readable unit string and returns its litre equivalent.
 *
 * Examples:
 *   "1L"    → 1.0
 *   "500ml" → 0.5
 *   "200ml" → 0.2
 *   "2L"    → 2.0
 *   "250g"  → 0   (non-liquid unit, returns 0)
 *
 * The function is intentionally permissive with whitespace and casing so that
 * strings like "1 L", "500 ML", or "1l" are all handled correctly.
 *
 * @param unit - The unit string stored on an InventoryItem (e.g. "1L", "500ml").
 * @returns The litre-equivalent as a number, or 0 if the unit is not a recognised liquid volume.
 */
export function parseUnitToLitres(unit: string): number {
  if (!unit) return 0;

  const normalised = unit.trim().toLowerCase().replace(/\s+/g, '');

  // Match patterns like "1l", "1.5l", "500ml"
  const litreMatch = normalised.match(/^(\d+(?:\.\d+)?)l$/);
  if (litreMatch) {
    return parseFloat(litreMatch[1]);
  }

  const mlMatch = normalised.match(/^(\d+(?:\.\d+)?)ml$/);
  if (mlMatch) {
    return parseFloat(mlMatch[1]) / 1000;
  }

  // Non-liquid unit (packets, kg, g, etc.) — return 0
  return 0;
}
