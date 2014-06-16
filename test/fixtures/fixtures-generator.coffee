#Use with http://www.json-generator.com/
users = [
  "{{repeat(10,10)}}"
  {
    name: "{{firstName}} {{surname}}"
    userid: "{{firstName}}"
    password: "{{lorem(1,words)}}{{numeric(10,20)}}"
  }
]
