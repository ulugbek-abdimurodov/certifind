import { stages } from "../app/search-data";

export function Workflow({
  step,
  loading,
  hasError,
}: {
  step: number;
  loading: boolean;
  hasError: boolean;
}) {
  return (
    <section className="workflow" aria-label="Fasi della ricerca">
      <div className="workflow-head">
        <span>IL PROCESSO</span>
        <span>Una ricerca, cinque passaggi</span>
      </div>
      <div className="steps">
        {stages.map((name, index) => {
          const isDone = step > index;
          // The last step is the only one that can fail: show "✗" instead of
          // "✓" when the search completed with an error.
          const isLastStep = index === stages.length - 1;
          const isFailed = isLastStep && hasError && step >= index;
          const isCurrent = step === index && loading;

          return (
            <div
              className={`step ${step >= index ? "step-done" : ""} ${
                isFailed ? "step-error" : ""
              } ${isCurrent ? "step-current" : ""}`}
              key={name}
            >
              <div className="step-node">
                {isFailed ? "✗" : isDone ? "✓" : `0${index + 1}`}
              </div>
              <span>{name}</span>
            </div>
          );
        })}
      </div>
    </section>
  );
}
