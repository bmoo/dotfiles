alias dk=docker-compose
alias k=kubectl
alias gitfilehist='gitlogfunc() { git log --format=%H -- $1 | head -n1}; gitlogfunc'

# go
alias t='go test -short ./...'
alias lint='/usr/local/bin/golangci-lint run --new-from-rev=origin/develop'
alias depgraph="go mod graph | modv | dot -T png | open -f -a /System/Applications/Preview.app"
alias outdated="go list -u -m -json all | go-mod-outdated"
alias cover='coverfunc() { t="/tmp/go-cover.$$.tmp"; go test -coverprofile=$t ./...; go tool cover -html=$t ; unlink $t }; coverfunc'

# kubernetes
alias kpod='kpodfunc() { kubectl get pods | grep $1 | head -n 1 | cut -f 1 -d " " }; kpodfunc'
alias kforward='kforwardfunc() { kubectl port-forward $(kpod $1) 8080:80 }; kforwardfunc'
alias klogs='klogsfunc() { kubectl logs -f $(kpod $1) }; klogsfunc'
