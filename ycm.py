
def FlagsForFile(filename, **kwargs):
    flags = [
        '-Wall',
        '-Wextra',
        '-Werror'
        '-pedantic',
        '-I',
        '.',
        #  '-isystem',
        #  '/usr/include',
        ]

    data = kwargs['client_data']
    filetype = data['&filetype']

    if filetype == 'c':
        flags += ['-xc']
    elif filetype == 'cpp':
        flags += ['-xc++']
        flags += ['-std=c++11']
    elif filetype == 'objc':
        flags += ['-ObjC']
    else:
        flags = []

    return {
        'flags':    flags,
        'do_cache': True
    }
