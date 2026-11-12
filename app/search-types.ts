export type AccreditationScope = {
  eaCode: number | null;
  eaDescription: string;
  scopeSection: string;
  proofUrl: string | null;
  isoStandard: string;
  accreditationStandard: string;
  accreditationBodyCode: string;
  certificateNumber: string;
  expiryDate: string | null;
};

export type Body = {
  id: number;
  name: string;
  country: string;
  accreditationBodyCode: string;
  accreditationBodyWebsite: string | null;
  /** Every accrediting AB; the card's own (accreditationBodyCode) comes first. */
  accreditationBodyCodes: string[];
  phone: string | null;
  email: string | null;
  website: string | null;
  address: string | null;
  sourceUrl: string | null;
  verifiedAt: string | null;
  proofUrl: string | null;
  eaCode: number;
  eaDescription: string;
  scopeSection: string;
  /** Distinct certification standards; scope rows are loaded per body for the drawer. */
  standards: string[];
  expiryDate: string | null;
};

export type SearchResponse = {
  resolvedEaCode: number;
  resolvedEaDescription: string;
  results: Body[];
  directory: boolean;
};

export type SearchOptions = {
  standards: string[];
  sectorsByStandard: Record<string, SectorOption[]>;
};

export type SectorOption = { code: number; name: string };

export type ResultFilter = "all" | "italy" |`accreditor:${string}`;

export type SearchPreset = {
  label: string;
  iso: string;
  sector: string;
};
