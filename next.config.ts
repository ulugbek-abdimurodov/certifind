import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Minimal self-contained server for the Docker image (see Dockerfile).
  output: "standalone",
  turbopack: {
    root: process.cwd(),
  },
};

export default nextConfig;
