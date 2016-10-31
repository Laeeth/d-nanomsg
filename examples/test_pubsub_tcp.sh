./pubsub server tcp://*:5555 & server=$! && sleep 1
./pubsub client tcp://*:5555 client0 & client0=$!
./pubsub client tcp://*:5555 client1 & client1=$!
./pubsub client tcp://*:5555 client2 & client2=$!
sleep 5
