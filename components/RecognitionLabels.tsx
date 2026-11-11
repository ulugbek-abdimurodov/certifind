import { recognitionLabels } from "../app/search-data";

/** EA / IAF badges for an accreditation body code. */
export function RecognitionLabels({ abCode }: { abCode: string }) {
  return (
    <span className="recognition-labels">
      {recognitionLabels(abCode).map((label) => (
        <span key={label} className={`recognition-label ${label.toLowerCase()}`}>
          {label}
        </span>
      ))}
    </span>
  );
}
