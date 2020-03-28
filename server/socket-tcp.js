const net = require('net');
const port = 1234;

const server = net.createServer((socket) => {
    console.log(`connected ${socket.id}`);

    socket.on('data', (data) => {
        console.log(data);
        socket.write(data);
    });

    // socket.end(`goodbye\n`);
});

server.on('error', (err) => {
    // throw err;
    console.log(err);
});

server.listen(port, () => {
    console.log('opened server on', server.address());
});
