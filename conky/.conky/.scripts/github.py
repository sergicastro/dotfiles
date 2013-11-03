import simplejson as json
import os
import httplib2

GITHUBAPI = "https://api.github.com/"

uris = {'repos': GITHUBAPI+"user/repos",
        'orgs': GITHUBAPI+"users/sergicastro/orgs", 
        'orgrepos': GITHUBAPI+"orgs/%(org)s/repos", 
        'blob': GITHUBAPI+"https://api.github.com/"}

def get(uri):
    h = httplib2.Http(cache=".cache")
    h.add_credentials(name="sergicastro",password="25abril1987")
    resp, content = h.request(uri=uri, method="GET", headers={"Authorization": "Basic c2VyZ2ljYXN0cm86MjVhYnJpbDE5ODc="})
    return resp, json.loads(content)



resp, repos = get(uri=uris['repos'])
if resp.status == 200:
    print '##### PERSONAL REPOS #####' 
    for repo in repos:
        print repo['name']
        print repo['ssh_url']

resp, orgs = get(uri=uris['orgs'])
if resp.status == 200:
    for org in orgs:
        resp, orgrepos = get(uri=uris['orgrepos'] % {'org':org['login']})
        if resp.status == 200:
            print '##### REPOS FROM %(org)s #####' % {'org':org['login']}
            for orgrepo in orgrepos:
                print orgrepo['name']
                resp, commits = get ((uris['orgrepos'] % {'org':org['login']})+"/"+orgrepo['name']+"/commits")
                print resp.status
                if resp.status == 200:
                    print commits
