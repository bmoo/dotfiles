alias dk=docker-compose
alias k=kubectl
alias dlogin='$(aws-vault exec --no-session verve -- aws ecr get-login --no-include-email --region us-west-2)'
alias couchshell='docker run --rm -ti --net=otas_default couchbase/server:4.6.3 /opt/couchbase/bin/cbq -u vagrant -p vagrant -engine=http://couchbase:8091/'
alias pg='PGPASSWORD=secret docker run -it --rm --network otas_default postgres psql -h postgres -U postgres'
alias nsqlog='nsqlogfunc() { docker run --rm --net=otas_default nsqio/nsq nsq_tail --nsqd-tcp-address=nsqd:4150 --topic=$1 }; nsqlogfunc'
alias geti='getifunc() { ssh puppet-east ./get-instance.sh $1 }; getifunc'
alias gotest='go test -count=1 -short ./...'
alias gitfilehist='gitlogfunc() { git log --format=%H -- $1 | head -n1}; gitlogfunc'
alias lint='golangci-lint run'

