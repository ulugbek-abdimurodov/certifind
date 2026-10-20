import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "CertiFind — Organismi di certificazione",
  description: "Trova organismi di certificazione accreditati per il tuo settore.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="it">
      <body suppressHydrationWarning>{children}</body>
    </html>
  );
}
