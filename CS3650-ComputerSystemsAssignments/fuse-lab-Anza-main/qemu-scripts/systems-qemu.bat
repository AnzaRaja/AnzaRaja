@echo off

SET IMAGE=systems-base.qcow2
IF NOT EXIST "%IMAGE%" (
  IF NOT EXIST "virtualbox.box" (
    echo Please download virtualbox.box and place it in this directory.
    echo Download URL: https://app.vagrantup.com/khoury-cs3650/boxes/base-environment/versions/2021.09.12/providers/virtualbox.box
    exit "1"
  )
  echo Preparing the QEMU image... 
  tar xzf virtualbox.box
  qemu-img convert -f vmdk -O qcow2 box-disk001.vmdk "%IMAGE%"
)
qemu-system-x86_64 "-M" "q35" "-cpu" "qemu64" "-smp" "4" "-m" "4096" "-rtc" "clock=vm,base=localtime" "-device" "virtio-gpu-pci" "-display" "default,show-cursor=on" "-device" "qemu-xhci" "-device" "usb-kbd" "-device" "usb-tablet" "-device" "intel-hda" "-device" "hda-duplex" "-vga" "virtio" "-hda" "%IMAGE%" "-nic" "user,model=virtio,hostfwd=tcp::2200-:22" "-nographic"
