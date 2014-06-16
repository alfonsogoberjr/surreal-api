module.exports =
  tokenConfigSecret: process.env.YOURAPP_CONFIG_SECRET or "abc123"
  corsAllowOrigin: process.env.CORS_ALLOW_ORIGIN or "http://localhost:9000"
  endpoint:
    conversations:
      required_post_params: [
        "to"
        "from"
        "body"
      ]

  development:
    db: "mongodb://localhost/databasedev"
    port: 5008
    app:
      name: "Project Name Dev"

  test:
    db: "mongodb://localhost/databasetest"
    port: 5009
    app:
      name: "Project Name Test"

  stage:
    port: process.env.PORT
    db: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
    app:
      name: "Project Name Stage"

  production:
    port: process.env.PORT or 5000
    switchboardPhoneNumber: process.env.SWITCHBOARD_PHONE_NUMBER
    db: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
    name: "Project Name"
