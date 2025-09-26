# SIMTER
![Licença Não Comercial](https://img.shields.io/badge/Licen%C3%A7a-N%C3%A3o--Comercial-red)
![Em Desenvolvimento](https://img.shields.io/badge/Status-Em%20Desenvolvimento-orange)

O **SIMTER - Sistema de Monitoramento de Equipamentos em Tempo Real** foi um projeto inicialmente desenvolvido para a **ProjETE 2k24**, uma feira de projetos tecnológicos realizada anualmente pela **ETE FMC**, a primeira escola técnica da América Latina e aprimorado completamente, em uma nova versão, para a **FETIN 2k25**, a feira de projetos do **INATEL**.  
O projeto, que atua como um sistema inteligente de rastreamento e gestão indoor de pessoas, ferramentas e ativos, alinhado aos pilares da Indústria 4.0, tem como foco proporcionar visibilidade em tempo real das operações industriais, otimizando o uso de recursos, automatizando tarefas e aumentando a eficiência operacional por meio da utilização de beacons e gateways BLE (Bluetooth Low Energy).  

</br>
<div align="center">
  <img src="./FotoEquipe.png" alt="Foto do Grupo" width="600">
</div>
</br>

---

## Funcionamento do projeto

O funcionamento do SIMTER é baseado em um sistema de beacons (rastreadores) e gateways (antenas responsáveis por receber os sinais desses beacons).
A todo momento, os beacons emitem sinais BLE, contendo informações como suas IDs, status e o instante exato da transmissão. Ao chegar em cada gateway, esses sinais apresentam diferentes intensidades, que são então medidas por eles e enviadas ao servidor, onde a informação é processada e convertida em uma estimativa de distância em relação ao beacon.

Com a distância do beacon em relação a pelo menos três gateways instalados na fábrica, torna-se possível determinar sua posição exata no ambiente a partir da triangulação desses dados. A partir disso, o sistema consegue identificar a proximidade desse beacon em relação a máquinas, funcionários ou outros elementos da fábrica, bem como registrar seu status e demais dados relevantes.

Com todas essas informações processadas, o aplicativo passa a exibi-las de forma organizada, permitindo visualizar beacons, funcionários e máquinas em uma tabela interativa ou em um gêmeo digital, que representa em tempo real a posição desses elementos no espaço. 

O sistema também conta com um sistema de tasks, no qual gestores podem criar tarefas que são automaticamente atribuídas ao funcionário mais próximo dos recursos necessários para sua execução e com um sistema de relatórios integrados, capaz de estimar, por exemplo, a quantidade de pedidos produzidos por cada máquina da fábrica, além de fornecer indicadores que apoiam a análise de produtividade e eficiência dos processos.

Para saber mais sobre o projeto, acesse o Notion dessa nova versão do SIMTER, documento desenvolvido ao longo de todo o processo de desenvolvimento do projeto pela equipe, ou acesse ao repositório da primeira versão do projeto, desenvolvida em 2024.
- [Notion](https://toothsome-mahogany-bd9.notion.site/FETIN-2k25-1fdf8230d9648099b91af4a47642808b?pvs=73)
- [GitHub](https://github.com/freitasj1/projetoSIMTER)

---

## Tecnologias Utilizadas

### Software:
- Comunicação: Bluetooth Low Energy (BLE)
- Aplicativo: Tabela interativa e Gêmeo digital
- Banco de Dados: MySQL 

### Hardware:
- Processamento: ESP32 C3 mini (Beacons) e ESP32 S3 (Gateways)
- Alimentação: Baterias 18650 e controlador de carga MODELO

### Linguagens e Bibliotecas:
- Linguagens de Programação: Python, C++, Dart, SQL
- Bibliotecas e Frameworks: Flutter, FastAPI
- Protocolos e Tecnologias: BLE, HTTP

---

## Fundadores

### Primeira versão:

- **João Pedro**  
  [LinkedIn](https://www.linkedin.com/in/joaopedrofreitasm/) | [GitHub](https://github.com/freitasj1)  

ANOTAR OS OUTROS MEMBROS E REDES

### Segunda versão:

- **João Pedro**  
  [LinkedIn](https://www.linkedin.com/in/joaopedrofreitasm/) | [GitHub](https://github.com/freitasj1)  
- **Kauã Ribeiro**  
  [LinkedIn](https://www.linkedin.com/in/kaua-ribeiro17/) | [GitHub](https://github.com/Kauakim)  
- **Giovanna Vono**  
  [LinkedIn](https://www.linkedin.com/in/giovanna-vono-fonseca-36b05a307/) | [GitHub](https://github.com/)  
- **Núbia Rezende**  

---

**Agradecimentos**  
O projeto contou com o apoio e orientação do professor **Ítalo Augusto de Sousa Tacca**.
