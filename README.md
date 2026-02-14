<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">

</head>

<body>

<h1>🚀 VM LAB - Infraestrutura Virtual com VirtualBox</h1>
<p><strong>Criado por:</strong> Cassiano Projetos IT</p>

<div class="section">
<h2>📌 Objetivo do Projeto</h2>
<p>
Este laboratório tem como objetivo criar uma infraestrutura virtual automatizada utilizando VirtualBox em ambiente Linux Server.
A estrutura servirá como base para futuras etapas do laboratório incluindo:
</p>
<ul>
<li>Docker</li>
<li>Cluster</li>
<li>Docker Swarm</li>
<li>MySQL</li>
<li>Apache</li>
</ul>
</div>

<div class="section">
<h2>🧱 Pré-requisitos</h2>
<ul>
<li>Ubuntu Server instalado</li>
<li>VirtualBox previamente instalado e configurado</li>
<li>Permissão root ou sudo</li>
<li>ISO do sistema operacional disponível</li>
</ul>
</div>

<div class="section">
<h2>⚙️ Script Utilizado</h2>
<p>Script principal:</p>
<code>vm_lab_orchestrator.sh</code>

<p>Funções do Script:</p>
<ul>
<li>Criação automatizada de máquinas virtuais</li>
<li>Configuração de CPU</li>
<li>Configuração de memória RAM</li>
<li>Criação de discos virtuais</li>
<li>Associação automática da ISO</li>
<li>Configuração de rede NAT Network</li>
<li>Inicialização automática das VMs</li>
</ul>
</div>

<div class="section">
<h2>▶️ Como Executar o Script</h2>

<h3>1. Dar permissão de execução</h3>
<pre>
chmod +x vm_lab_orchestrator.sh
</pre>

<h3>2. Executar o script</h3>
<pre>
sudo ./vm_lab_orchestrator.sh
</pre>

<h3>3. Informações solicitadas durante execução</h3>
<ul>
<li>Quantidade de máquinas virtuais</li>
<li>Nome das VMs</li>
<li>Quantidade de RAM</li>
<li>Quantidade de CPUs</li>
<li>Tamanho do disco</li>
</ul>

<p>O sistema operacional é padrão conforme definido no script.</p>
</div>

<div class="section">
<h2>🌐 Configuração de Rede</h2>
<p>Todas as máquinas são criadas utilizando:</p>
<pre>
NAT Network
</pre>

<p>Isso permite:</p>
<ul>
<li>Comunicação entre as VMs</li>
<li>Acesso à internet</li>
<li>Ambiente isolado para laboratório</li>
</ul>
</div>

<div class="section">
<h2>🖥️ Acesso à Instalação do Sistema</h2>
<p>
Após a criação das máquinas virtuais, a instalação do sistema operacional é realizada via:
</p>
<ul>
<li>RDP (recomendado para instalação inicial)</li>
<li>SSH após instalação completa</li>
</ul>
</div>

<div class="section">
<h2>📦 Estrutura do Projeto</h2>
<pre>
vm-lab/
│
├── vm_lab_orchestrator.sh
├── README.html
└── docs/
</pre>
</div>

<div class="footer">
<p>Projeto desenvolvido para laboratório técnico e certificação.</p>
<p><strong>Autor:</strong> Cassiano Projetos IT</p>
</div>

</body>
</html>
