#!/bin/bash

BASE_DIR="/vm"
ISO_DIR="$BASE_DIR/isos"
DISK_DIR="$BASE_DIR/disks"
SCRIPT_DIR="$BASE_DIR/scripts"
LOG_DIR="$BASE_DIR/logs"
TEMPLATE_DIR="$BASE_DIR/templates"

ISO_PATH=""

REDE_NOME="rede-vms"
REDE_SUBNET="10.0.3.0/24"

# -----------------------------
criar_estrutura() {

echo "Criando estrutura /vm..."

mkdir -p "$ISO_DIR"
mkdir -p "$DISK_DIR"
mkdir -p "$SCRIPT_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$TEMPLATE_DIR"

}

# -----------------------------
baixar_iso() {

read -p "Deseja baixar uma ISO agora? (s/n): " RESP

if [[ "$RESP" == "s" ]]; then

read -p "Cole o link da ISO: " ISO_LINK

FILE_NAME=$(basename "$ISO_LINK")

echo "Baixando ISO..."
wget -O "$ISO_DIR/$FILE_NAME" "$ISO_LINK"

ISO_PATH="$ISO_DIR/$FILE_NAME"

else

echo "ISOs disponíveis:"
ls "$ISO_DIR"

read -p "Digite o nome da ISO existente: " ISO_NAME

ISO_PATH="$ISO_DIR/$ISO_NAME"

fi
}

# -----------------------------
selecionar_rede() {

echo ""
echo "Tipo de rede:"
echo "1 - NAT"
echo "2 - NAT NETWORK"
echo "3 - BRIDGED"
echo "4 - HOST ONLY"

read -p "Escolha: " NETOP

case $NETOP in

1) NET_MODE="nat" ;;

2)
NET_MODE="natnetwork"
vboxmanage natnetwork add \
--netname "$REDE_NOME" \
--network "$REDE_SUBNET" \
--enable \
--dhcp on 2>/dev/null
;;

3)
NET_MODE="bridged"

mapfile -t IFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v lo)

for i in "${!IFACES[@]}"; do
echo "$((i+1)) - ${IFACES[$i]}"
done

read -p "Escolha interface: " IDX
BRIDGE_IF=${IFACES[$((IDX-1))]}
;;

4) NET_MODE="hostonly" ;;

*) echo "Opção inválida"; exit ;;
esac
}

# -----------------------------
config_padrao() {

echo ""
echo "Config LAB sugerida:"
echo "RAM: 3072 MB"
echo "CPU: 2"
echo "HD: 40 GB"

read -p "RAM MB: " RAM
read -p "CPUs: " CPU
read -p "HD GB: " HD
}

# -----------------------------
criar_vms() {

criar_estrutura
baixar_iso
selecionar_rede
config_padrao

read -p "Quantas VMs deseja criar: " QTD

for ((i=1;i<=QTD;i++)); do

read -p "Nome da VM $i: " VM
read -p "Porta VRDE (ex: 500$i): " VRDE

vboxmanage createvm --name "$VM" --ostype Ubuntu_64 --register

if [ "$NET_MODE" == "natnetwork" ]; then
NETCFG="--nic1 natnetwork --nat-network1 $REDE_NOME"
elif [ "$NET_MODE" == "bridged" ]; then
NETCFG="--nic1 bridged --bridgeadapter1 $BRIDGE_IF"
else
NETCFG="--nic1 $NET_MODE"
fi

vboxmanage modifyvm "$VM" \
--memory "$RAM" \
--cpus "$CPU" \
--vram 8 \
--boot1 dvd \
--boot2 disk \
$NETCFG \
--ioapic on \
--vrde on \
--vrdeport "$VRDE"

vboxmanage createhd \
--filename "$DISK_DIR/$VM.vdi" \
--size $(($HD*1024)) \
--format VDI

vboxmanage storagectl "$VM" \
--name "SATA Controller" \
--add sata \
--controller IntelAhci

vboxmanage storageattach "$VM" \
--storagectl "SATA Controller" \
--port 0 \
--device 0 \
--type hdd \
--medium "$DISK_DIR/$VM.vdi"

vboxmanage storageattach "$VM" \
--storagectl "SATA Controller" \
--port 1 \
--device 0 \
--type dvddrive \
--medium "$ISO_PATH"

echo "VM $VM criada!"

done
}

# -----------------------------
start_all() {
for VM in $(vboxmanage list vms | awk -F\" '{print $2}')
do
vboxmanage startvm "$VM" --type headless
done
}

# -----------------------------
stop_all() {
for VM in $(vboxmanage list runningvms | awk -F\" '{print $2}')
do
vboxmanage controlvm "$VM" acpipowerbutton
done
}

# -----------------------------
status_all() {
vboxmanage list runningvms
}

# -----------------------------
menu() {

echo ""
echo "===== VM LAB ORCHESTRATOR ====="
echo "1 - Criar VMs"
echo "2 - Iniciar todas"
echo "3 - Parar todas"
echo "4 - Status"
echo "0 - Sair"

read -p "Escolha: " OP

case $OP in
1) criar_vms ;;
2) start_all ;;
3) stop_all ;;
4) status_all ;;
0) exit ;;
*) echo "Opção inválida" ;;
esac
}

while true; do
menu
done
