# Steps

Running without Docker:

```
yarn create next-app frontend --typescript --eslint --no-tailwind --no-src-dir --app --no-import-alias
cd ./frontend
yarn config set --home enableTelemetry 0
yarn add @mantine/core @mantine/hooks
yarn dev
```

next.config.mjs:

```
/** @type {import('next').NextConfig} */
const nextConfig = {
    output: 'standalone',
  };

  export default nextConfig;
```

docker-compose.yml outside frontend folder...

Dockerfile inside frontend folder...
