"use client";

import React, { useState } from "react";
import {
  SimpleGrid,
  Notification,
  Select,
  Divider,
  Container,
  Center,
  Loader,
  FileInput,
  Text,
  Space,
  FileButton,
  Button,
} from "@mantine/core";

export default function HomePage() {
  const [file, setFile] = useState<File | null>(null);

  const handleSubmit = async () => {
    if (!file) {
      alert("No file selected");
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    try {
      const response = await fetch("http://localhost:7180/upload", {
        method: "POST",
        body: formData,
      });
      console.log("response", response);

      if (response.ok) {
        alert("File uploaded successfully");
      } else {
        alert("File upload failed");
      }
    } catch (error) {
      console.error("Error uploading file:", error);
      alert("Error uploading file");
    }
  };

  return (
    <>
      <Space h="xl" />
      <Container>
        <SimpleGrid cols={1} spacing="xs">
          <Notification
            withBorder
            withCloseButton={false}
            title={"implementations"}
          >
            {"Demo functionality of some common functionalities..."}
          </Notification>
        </SimpleGrid>
      </Container>
      <Space h="xl" />

      <Container>
        <Text size="xl">#1 Uploading files to S3</Text>
        <Space h="xs" />

        <FileButton onChange={setFile}>
          {(props) => <Button {...props}>Choose file...</Button>}
        </FileButton>

        {file && (
          <Text size="sm" mt="sm">
            Picked file: {file.name}
          </Text>
        )}

        {file && <Button onClick={handleSubmit}>Submit</Button>}

        <Divider my="md" />
      </Container>
    </>
  );
}
