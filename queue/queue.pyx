# distutils: include_dirs = /usr/local/include/libcalg-1.0/libcalg

cimport cqueue

cdef class Queue:
    cdef cqueue.Queue* _c_queue

    # This is the constructor that is invoked even before __init__
    # Its use is restricted to initialize cdef fields when a new object is instantiated.
    def __cinit__(self):
        self._c_queue = cqueue.queue_new()
