package main

import (
	"context"
	"fmt"
	"net/http"
	"log"
    "time"
    "strings"

    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"

    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)



func main() {
	fmt.Println("Hello, 世界")

	
	// start create Credential of connect to mangoDB 

	var cred options.Credential
	// user name and password of database
	cred.Username = "root"
	cred.Password = "example"


    // start process : gin web framework

	r := gin.Default()


	// 
	r.Use(cors.New(cors.Config{
	  AllowOrigins:     []string{"http://localhost"},
	  AllowMethods:     []string{"POST","PUT", "PATCH"},
	  AllowHeaders:     []string{"Origin"},
	  ExposeHeaders:    []string{"Content-Length"},
	  AllowCredentials: true,
	  AllowOriginFunc: func(origin string) bool {
	   return origin == "https://github.com"
	  },
	  MaxAge: 12 * time.Hour,
	 }))
	
	corsConfig := cors.DefaultConfig()

	corsConfig.AllowOrigins = []string {"http://localhost"}
	// To be able to send tokens to the server.
	corsConfig.AllowCredentials = true

	// Register the middleware
	r.Use(cors.New(corsConfig))



	r.GET("/dblist", func(c *gin.Context) {
		
		// start process of connect to mangoDB 

		client, err := mongo.NewClient(options.Client().ApplyURI("mongodb://mongo:27017").SetAuth(cred))
	    if err != nil {
	        log.Fatal(err)
	    }

	    ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	    err = client.Connect(ctx)
	    if err != nil {
	        log.Fatal(err)
	    }
	    defer client.Disconnect(ctx)

	     // end process of connect to mangoDB 

		// show list of databases
		databases, err := client.ListDatabaseNames(ctx, bson.M{})
		if err != nil {
		    log.Fatal(err)
		}


		
		c.JSON(http.StatusOK, gin.H{
			"message": strings.Join(databases," , "),
		})


		// c.JSON(http.StatusOK, gin.H{
		// 	"message": "pong",
		// })
	})

	//Parameters in path

	r.GET("/user/:name/:action", func(c *gin.Context) {
		name := c.Param("name")
		action := c.Param("action")
		message := name + " is " + action
		c.String(http.StatusOK, message)
	})

	//Multipart/Urlencoded Form

	r.POST("/post", func(c *gin.Context) {
		message := c.PostForm("message")
		nick := c.DefaultPostForm("nick", "anonymous")

		c.JSON(200, gin.H{
			"status":  "posted",
			"message": message,
			"nick":    nick,
		})
	})






	
	r.Run()

	// end process : gin web framework



}
