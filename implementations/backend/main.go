package main

import (
	"fmt"
	"log"
	"net/http"
	"path/filepath"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func uploadFile(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	//todo: validating form, big file, file type, etc...

	file, fileHeader, err := r.FormFile("file")
	if err != nil {
		http.Error(w, "Error retrieving the file", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// UPLOAD LOCALLY TO SERVER

	// err = os.MkdirAll("./uploads", os.ModePerm)
	// if err != nil {
	// 	http.Error(w, err.Error(), http.StatusInternalServerError)
	// 	return
	// }

	// dst, err := os.Create(fmt.Sprintf("./uploads/%d%s", time.Now().UnixNano(), filepath.Ext(fileHeader.Filename)))
	// if err != nil {
	// 	http.Error(w, err.Error(), http.StatusInternalServerError)
	// 	return
	// }

	// defer dst.Close()

	// _, err = io.Copy(dst, file)
	// if err != nil {
	// 	http.Error(w, err.Error(), http.StatusInternalServerError)
	// 	return
	// }

	// UPLOAD TO S3
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("eu-central-1"),
	})
	if err != nil {
		fmt.Println("Error creating session", err.Error())
		http.Error(w, "Error creating session", http.StatusInternalServerError)
		return
	}
	fmt.Println("succesfully created session")

	svc := s3.New(sess)

	_, err = svc.PutObject(&s3.PutObjectInput{
		Bucket: aws.String("my-s3-upload-api-bucket"),
		Key:    aws.String(fmt.Sprintf("%d%s", time.Now().UnixNano(), filepath.Ext(fileHeader.Filename))),
		Body:   file,
		//ACL:    aws.String("public-read"), // Set ACL as needed
	})
	if err != nil {
		fmt.Println("Error uploading the file", err.Error())
		http.Error(w, "Error uploading the file", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, " File uploaded successfully")
}

func main() {
	http.HandleFunc("/upload", uploadFile)
	log.Println("Server started on: http://localhost:7180")
	log.Fatal(http.ListenAndServe(":7180", nil))
}
