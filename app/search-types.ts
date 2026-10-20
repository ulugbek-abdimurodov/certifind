export type Body = {
  id: number;
  name: string;
  country: string;
  accreditationBodyCode: string;
  isIafMla: boolean;
  hasItalianAuditors: boolean;
  isCommercialPartner: boolean;
  phone: string | null;
  email: string | null;
  website: string | null;
  address: string | null;
  proofUrl: string | null;
  eaCode: number;
  eaDescription: string;
  scopeSection: string;
};

export type SearchResponse = {
  resolvedAteco: string;
  resolvedEaCode: number;
  resolvedEaDescription: string;
  totalResults: number;
  results: Body[];
};

export type ResultFilter = "all" | "italy" | "foreign" | `accreditor:${string}`;
