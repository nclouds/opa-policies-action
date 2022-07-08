const fs = require('fs');
var GitHub = require('github-api');
const Issue = require('github-api/dist/components/Issue');
var opa_output = fs.readFileSync('REPORT.md', {encoding:'utf8', flag:'r'})

var output = `
${opa_output}
`

// Create Github URL
var gh = new GitHub({
    token: process.env.GITHUB_TOKEN
 });

 // Get PR NUmber 
const gitHubRef  = process.env.GITHUB_REF
var prNumber = gitHubRef.split("/")[2]

var issue = new Issue(process.env.GITHUB_REPOSITORY, gh.__auth, gh.__apiBase)
issue.createIssueComment(prNumber,output).then(response => console.log(response.status))
