#!/usr/bin/env awk -f

# BEGIN{FS=""}
# {
#     maxNF=(maxNF<NF)?NF:maxNF;
#     for(i=1;i<=NF;i++) {
#         Filds[i,NR]=$i;
#     }
# }
# END{
# for(i=1;i<=maxNF;i++){
#     for(j=1;j<=NR;j++){
#         printf "%-2s",Filds[i,j];
#     }
#     print "";
#   }
# }

BEGIN{
    ORS=""
    max=length($0)
}
{
    if(max<length($0)){
        max=length($0)
    }
    for(t=1;t<=length($0);t++){
        array[NR,t]=substr($0,t,1)
        # print array[NR,t]
    }
}
END{
        for(n=1;n<=max;n=n+2){
            for(i=FNR;i>=1;i--){
                    printf "%-2s", array[i,n]array[i,n+1]
            }
            print "\n"
        }
}