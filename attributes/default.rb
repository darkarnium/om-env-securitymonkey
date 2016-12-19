# Ensure apt-get update and build-essential is run / installed at compile time.
override['apt']['compile_time_update'] = true
override['build-essential']['compile_time'] = true
