#!/bin/sh


# b=''
# TCOUNT=0
# for ((i=0;$i<=100;i+=1))
# do
#     TCOUNT=`expr $i % 4`
#     printf "progress: [%-1s] %d%%\r" $b $i
#     sleep 0.05
#     # echo $TCOUNT
#     case  $TCOUNT in
#         "0")
#             b='-'
#             ;;
#         "1")
#             b='\'
#             ;;
#         "2")
#             b='|'
#             ;;
#         "3")
#             b='/'
#             ;;
#     esac
# done
# echo
rotate(){
    b=''
    TCOUNT=0
    # for ((i=0;$i<=100;i+=1))
    # do
    #     TCOUNT=`expr $i % 4`
    #     printf "progress: [%-1s] %d%%\r" $b $i
    #     sleep 0.05
    #     # echo $TCOUNT
    #     case  $TCOUNT in
    #         "0")
    #             b='-'
    #             ;;
    #         "1")
    #             b='\'
    #             ;;
    #         "2")
    #             b='|'
    #             ;;
    #         "3")
    #             b='/'
    #             ;;
    #     esac
    # done
    COUNT=100000
    i=0
    while [[ $i <=$COUNT ]]; do
        TCOUNT=`expr $i % 4`
        printf "progress: [%-1s] %d%%\r" $b $i
        sleep 0.05
        case  $TCOUNT in
            "0")
                b='-'
                ;;
            "1")
                b='\'
                ;;
            "2")
                b='|'
                ;;
            "3")
                b='/'
                ;;
        esac
        i=`expr $i + 1`;
    done
    echo
}


rotate &

ROTATE_PID=$!

sleep 20

kill -9 $ROTATE_PID