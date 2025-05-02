package main

import (
	"github.com/gin-gonic/gin"
	"os"
)

func main() {
	r := gin.Default()

	r.Static("/static", "./frontend/dist")

	r.GET("/", func(c *gin.Context) {
		c.File("./frontend/dist/index.html")
	})

	r.Run(":" + os.Getenv("APP_PORT"))
}
