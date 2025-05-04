package main

import (
	"database/sql"
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

type TestRow struct {
	ID   int    `json:"id"`
	Data string `json:"data"`
}

func main() {
	dbHost := os.Getenv("POSTGRES_HOST")
	dbPort := os.Getenv("POSTGRES_PORT")
	dbUser := os.Getenv("POSTGRES_USER")
	dbPassword := os.Getenv("POSTGRES_PASSWORD")
	dbName := os.Getenv("POSTGRES_DB")

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", dbHost, dbPort, dbUser, dbPassword, dbName)
	fmt.Println("Connecting to:", connStr)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		panic(fmt.Sprintf("failed to open database: %v", err))
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		panic(fmt.Sprintf("failed to connect to database: %v", err))
	}
	fmt.Println("Successfully connected to the database!")

	r := gin.Default()

	r.Static("/static", "./frontend/dist")

	r.GET("/testdb", func(c *gin.Context) {
		rows, err := db.Query("SELECT * FROM test_table")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		defer rows.Close()

		var results []TestRow

		for rows.Next() {
			var row TestRow
			if err := rows.Scan(&row.ID, &row.Data); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			results = append(results, row)
		}

		if err := rows.Err(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, results)
	})

	r.GET("/", func(c *gin.Context) {
		c.File("./frontend/dist/index.html")
	})

	r.Run(":" + os.Getenv("APP_PORT"))
}
