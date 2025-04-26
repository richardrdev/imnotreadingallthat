package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.Static("/static", "./frontend/dist")

	r.GET("/", func(c *gin.Context) {
		c.File("./frontend/dist/index.html")
	})

	r.Run(":8080")
}
