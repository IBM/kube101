!SLIDE[bg=_images/backgrounds/white_bg.png]
# What are Containers

* A group of processes run in isolation
* Similar to VMs but managed at the process level
* All processes MUST be able to run on the shared kernel

!SLIDE[bg=_images/backgrounds/white_bg.png]
# Container Namespaces

Each container has its own set of "namespaces" (isolated view)

    @@@ Console
        PID - process IDs
        USER - user and group IDs
        UTS - hostname and domain name
        NS - mount points
        NET - Network devices, stacks, ports
        IPC - inter-process communications, message queues
        cgroups - controls limits and monitoring of resources

Docker gives it its own root filesystem


!SLIDE[bg=_images/container_vs_vm.png] background-fit


!SLIDE[bg=_images/backgrounds/white_bg.png]
# Why Containers?

* Fast startup time - only takes milliseconds to:
 * Create a new directory
 * Lay-down the container's filesystem
 * Setup the networks, mounts, ...
 * Start the process

* Better resource utilization
 * Can fit far more containers than VMs into a host


!SLIDE[bg=_images/backgrounds/white_bg.png]
# What is Docker?

* Tooling to manage containers
 * Containers are not new
 * Docker just made them easy to use

* Docker creates and manages the lifecycle of containers
 * Setup filesystem
 * CRUD container
 * Setup networks
 * Setup volumes / mounts
 * Create: start new process telling OS to run it in isolation
