./pipeline node0 ipc:///tmp/pipeline.ipc & node0=$! && sleep 1
./pipeline node1 ipc:///tmp/pipeline.ipc "Hello, World!"
./pipeline node1 ipc:///tmp/pipeline.ipc "Goodbye."
./reqrep node0 ipc:///tmp/reqrep.ipc & node0=$! && sleep 1
./reqrep node1 ipc:///tmp/reqrep.ipc
kill $node0
