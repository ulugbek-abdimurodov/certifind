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
  /** Set on product certification (ISO/IEC 17065) results only. */
  product?: ProductMatch;
};

export type SearchResponse = {
  resolvedEaCode: number;
  resolvedEaDescription: string;
  results: Body[];
  directory: boolean;
  /** Set on product certification results: the criteria searched, e.g. "IFS Food · Alimenti e mangimi". */
  productSummary?: string;
};

/** Which search the form is on. */
export type Activity = "management" | "product";

/** One line of an ISO/IEC 17065 scope annex. */
export type ProductScopeLine = {
  lineNo: number;
  /** Catalogue scheme name, when the line was matched to one. */
  scheme: string | null;
  industry: string | null;
  productText: string | null;
  productTextEn: string | null;
  /** Scheme as printed in the annex. */
  schemeText: string | null;
  normativeDocs: string | null;
  standardRefs: string | null;
  accreditationBodyCode: string;
  certificateNumber: string;
  expiryDate: string | null;
  proofUrl: string | null;
};

export type ProductMatch = {
  /** Distinct catalogue schemes among the matching lines. */
  schemes: string[];
  /** The first matching lines; the drawer loads the body's full scope. */
  lines: ProductScopeLine[];
  matchCount: number;
};

/** A product search result as the API returns it. */
export type ProductBodyCard = Omit<
  Body,
  "eaCode" | "eaDescription" | "scopeSection" | "standards" | "product"
> &
  ProductMatch;

export type ProductOptions = {
  industries: { code: string; name: string }[];
  schemes: { code: string; industries: string[] }[];
};

export type ProductCriteria = {
  scheme: string;
  industry: string;
  product: string;
};

export type SearchOptions = {
  standards: string[];
  sectorsByStandard: Record<string, SectorOption[]>;
};

export type SectorOption = { code: number; name: string };

export type ResultFilter = "all" | `accreditor:${string}`;

export type SearchPreset = {
  label: string;
  iso: string;
  sector: string;
};
