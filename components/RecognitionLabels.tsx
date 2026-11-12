import { recognitionLabels } from "../app/search-data";

/** EA / IAF badges for one AB code, or the union for several. */
export function RecognitionLabels({ abCode, abCodes }: { abCode?: string; abCodes?: string[] }) {
  const labels = [...new Set((abCodes ?? [abCode ?? ""]).flatMap(recognitionLabels))];
  return (
    <span className="recognition-labels">
      {labels.map((label) => (
        <span key={label} className={`recognition-label ${label.toLowerCase()}`}>
          {label}
        </span>
      ))}
    </span>
  );
}
