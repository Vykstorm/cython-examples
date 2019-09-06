# distutils: include_dirs = /usr/local/include/libcalg-1.0/libcalg

cimport cqueue

cdef class Queue:
    cdef cqueue.Queue* _c_queue

    # This is the constructor that is invoked even before __init__
    # Its use is restricted to initialize cdef fields when a new object is instantiated.
    def __cinit__(self):
        self._c_queue = cqueue.queue_new()
        # We can make our code more safe: The only way queue_new() can fail is
        # because of a memory error (in that case, returns NULL)
        if self._c_queue is NULL:
            # We raise MemoryError in such case
            raise MemoryError

    # This method is called when reference count of the object becomes zero.
    def __dealloc__(self):
        # We free the memory (if it was allocated before)
        if self._c_queue is not NULL:
            # By calling queue_free
            cqueue.queue_free(self._c_queue)


    # This method appends a new int value to the queue.
    cpdef append(self, int value):
        # Same considerations applied as in queue_new() for memory management.
        # We cast the integer value to void* type to store it in the qeue.
        if not cqueue.queue_push_tail(self._c_queue, <cqueue.QueueValue><Py_ssize_t>value):
            raise MemoryError


    # This method returns the head of the queue
    cpdef int peek(self) except? -1:
        # Call queue_peek_head(). It returns (void*) but we cast it to Py_ssize_t
        # (there is no precission loss in such conversion).
        # If the queue is empty, queue_peek_head returns zero (in that case we raise an exception)
        cdef int item = <Py_ssize_t>cqueue.queue_peek_head(self._c_queue)
        if item == 0:
            # Note that value 0 can also be a valid value in the queue. We make an additional
            # check...
            if cqueue.queue_is_empty(self._c_queue):
                # Queue is empty
                raise IndexError('Queue is empty')
            # Queue is not empty, value is zero.

        # We return the item. In case of error, cython needs to tell somehow to the caller code,
        # an specific value to indicate that an error occured. except? -1 speficies that in case of error,
        # the value returned to the caller is -1, but -1 can also be a regular queue item. Is up to the caller
        # to check the function  PyErr_Occurred() if the function returned -1
        return item



    # This method returns and remove the head of the queue
    cpdef int pop(self) except? -1:
        # This is the same as peek() but doesnt remove the item from the queue.
        # We need to check emptyness of the queue before removing the item this time.
        if cqueue.queue_is_empty(self._c_queue):
            raise IndexError('Queue is empty')
        return <Py_ssize_t>cqueue.queue_pop_head(self._c_queue)


    # __bool__ is interpreted as __bool__ in Python 3 or __nonzero__ in Python 2
    # Returns True if the queue is not empty. False otherwise
    def __bool__(self):
        return not cqueue.queue_is_empty(self._c_queue)

    # This method takes an arbitrary iterable and appends its contents to the queue.
    def extend(self, items):
        for item in items:
            self.append(item)
