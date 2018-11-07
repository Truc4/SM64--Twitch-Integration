function connectToNode()
    -- Need to send random garbage to the socket in order for Bizhawk to initalize the connection.
    -- ¯\_(ツ)_/¯
    console.writeline("Connecting...");
    comm.socketServerSetTimeout(0);
    comm.socketServerSend("Wake up!");
    comm.socketServerResponse();
    return true;
end

connectToNode()
