# FPCPoll
##Small library for easy calling poll (fpPoll) in FPC
# Using
You have a socket named "sock" and would like to call a procedure "OnAccept" when a read is available. Then the usage would be...

```
uses
PollList,
PollPart,
PollTypes;
...
var
list: TPollList;
p: TPollPart;
...

list := TPollList.Create;
p := TPollPart.Create(sock, nil, @OnAccept, nil, nil, nil, nil);
list.Add(p);

p.Read := true; //need read from socket (set POLLIN flag)
p.OnClosed := @OnClosed // instead of nil in constructor, or as property, you can also track the events
                        // OnWritable, OnReadable, OnClosed, OnError, OnUrgent, OnInvalid
                    // aka POLLOUT     POLLIN      POLLHUP   POLLERR  POLLPRI   POLLNVAL

while(true) do list.BuildAndCall(100); //call fpPoll with timeout 100 ms

list.free;

```

More about Poll - https://www.man7.org/linux/man-pages/man2/poll.2.html


