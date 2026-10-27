export type AccreditationScope = {
  eaCode: number | null;
  eaDescription: string;
  scopeSection: string;
  proofUrl: string | null;
  isoStandard: string;
};

export type Body = {
  id: number;
  name: string;
  country: string;
  accreditationBodyCode: string;
  isIafMla: boolean;
  phone: string | null;
  email: string | null;
  website: string | null;
  address: string | null;
  proofUrl: string | null;
  eaCode: number;
  eaDescription: string;
  scopeSection: string;
  scopes: AccreditationScope[];
};

export type SearchResponse = {
  resolvedAteco: string;
  resolvedEaCode: number;
  resolvedEaDescription: string;
  totalResults: number;
  results: Body[];
  directory: boolean;
};

export type SearchOptions = {
  standards: string[];
  sectors: { code: number; name: string }[];
};

export type ResultFilter = "all" | "italy" | "foreign" | `accreditor:${string}`;

export type SearchPreset = {
  label: string;
  iso: string;
  sector: string;
  ateco: string;
};
