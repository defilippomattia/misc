# Introduction

Steps needed for starting a new frontend project (vite + mantine)

1. Install node using nvm https://github.com/nvm-sh/nvm

2. Create vite project
```
npm create vite@latest my-fe-project -- --template react-ts
cd my-fe-project/
npm install @mantine/core @mantine/hooks
npm install --save-dev postcss postcss-preset-mantine postcss-simple-vars
```
3. Initial config

```
cat << 'EOF' > postcss.config.cjs
module.exports = {
  plugins: {
    'postcss-preset-mantine': {},
    'postcss-simple-vars': {
      variables: {
        'mantine-breakpoint-xs': '36em',
        'mantine-breakpoint-sm': '48em',
        'mantine-breakpoint-md': '62em',
        'mantine-breakpoint-lg': '75em',
        'mantine-breakpoint-xl': '88em',
      },
    },
  },
};
EOF

rm src/App.tsx
cat << 'EOF' > src/App.tsx
import '@mantine/core/styles.css';
import { MantineProvider, Button, Text } from '@mantine/core';

export default function App() {
  return (
    <MantineProvider>
      <div>
        <Text size="xl">
          Hello from Mantine!
        </Text>
        <Button color="blue">
          Click Me
        </Button>
      </div>
    </MantineProvider>
  );
}
EOF

npm run dev
```

