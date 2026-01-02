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
