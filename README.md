# Painéis de IA no Google Colab — um play e pronto

Dois painéis visuais que rodam de graça no Google Colab. Você abre o link, aperta **um** botão,
espera, e usa numa página cheia de botões. **Não precisa escrever código nenhum.**

| | Para quê | Link |
|---|---|---|
| **Fooocus** | **Fotos.** Leve e rápido, o mais fácil de todos | [abrir](https://colab.research.google.com/github/icmwalter-cyber/paineis-colab/blob/main/fooocus_colab.ipynb) |
| **WanGP** | **Vídeos** (e imagens). Anima uma foto sua | [abrir](https://colab.research.google.com/github/icmwalter-cyber/paineis-colab/blob/main/wangp_colab.ipynb) |

Endereços para copiar e colar:

```
https://colab.research.google.com/github/icmwalter-cyber/paineis-colab/blob/main/fooocus_colab.ipynb
https://colab.research.google.com/github/icmwalter-cyber/paineis-colab/blob/main/wangp_colab.ipynb
```

---

## Como usar (vale para os dois)

1. **Ligue a placa de vídeo.** Menu → **Ambiente de execução** → **Alterar o tipo de ambiente de
   execução** → marque **T4 GPU** → **Salvar**.
   *A placa de vídeo é a peça que faz a conta pesada. Sem ela o painel não liga, e os cadernos
   travam de propósito avisando isso.*
2. Aperte o **play** na única célula.
3. Autorize o **Google Drive** quando a janela do Google aparecer.
4. Espere o **link azul terminado em `.gradio.live`** e clique nele.

**A primeira vez demora** (5 a 15 minutos): ele está baixando o programa e o modelo. Não é
travamento. Da segunda vez em diante é bem mais rápido.

> **Não espalhe o endereço `.gradio.live`.** Ele abre o painel para qualquer pessoa que o tenha,
> sem senha, enquanto a sua sessão estiver ligada — e quem entrar estará usando a sua cota do
> Colab. Mande só para quem você quer que use, ou não mande para ninguém.

**Não feche a aba do Colab** enquanto estiver usando o painel — é ela que está rodando tudo.
O link do painel vale enquanto essa aba estiver viva; amanhã será um link novo.

---

## Onde ficam os arquivos

Tudo no **seu** Google Drive, na pasta que você escolher na caixinha `PASTA_NO_DRIVE`.

**Fooocus** (padrão `Fooocus`):

| Pasta | O que guarda |
|---|---|
| `saida` | as fotos geradas |
| `loras` | arquivos `.safetensors` de LoRA (rostos e estilos treinados) |

**WanGP** (padrão `WanGP`):

| Pasta | O que guarda |
|---|---|
| `outputs` | os vídeos gerados |
| `loras` | as LoRAs (ponha em `loras/wan`) |
| `hf-cache` | os modelos baixados, vários GB — é o que evita baixar tudo de novo |

> No Fooocus os modelos grandes **não** vão para o Drive de propósito: baixar do site oficial é
> mais rápido do que ler 7 GB do Drive toda vez que você liga. No WanGP vão, porque lá são muitos
> modelos diferentes e baixar de novo custaria caro.

---

## Configurações que funcionam na placa gratuita (T4)

### Fooocus

Não precisa mexer em quase nada. Escreva o que quer no campo de texto e clique em **Generate**.
Marque **Advanced** à esquerda para escolher proporção (**Aspect Ratios**) e para ligar LoRAs.

### WanGP — para animar uma foto

| Campo | Valor |
|---|---|
| Modelo | **Wan 2.2 TI2V 5B**, versão **Fast** |
| Modo | **Start with Image** (parte de uma foto — é o que segura o rosto) |
| Category / Resolution | **480p** / **480x832 (9:16)** para Reels e Stories |
| Number of frames | **49** (2 s) para testar, **121** (5 s) para valer |
| Inference Steps | **8** na versão Fast (**50** na Default) |
| Guidance (CFG) | **1** na versão Fast — obrigatório, senão a imagem estraga |
| Enhance Prompt using a LLM | **Disabled** |

A versão **Fast** faz 8 passadas de refino em vez de 50: perde um pouco de detalhe e fica cerca
de 6× mais rápida. Na placa gratuita, teste sempre no Fast e só repita no Default no final.

Para usar uma LoRA no WanGP: ponha o `.safetensors` em `loras/wan`, marque **Advanced Mode**,
vá na aba **LoRAs**, clique em **Refresh** e ligue a caixinha dela.

---

## Se der erro em inglês

Procure a **última linha** — é lá que está o motivo.

**Falou em `CUDA` ou `Torch not compiled`?** A sessão está **sem placa de vídeo**. Volte ao
passo 1. É de longe o erro mais comum.

**Não aparece link nenhum, mas também não há erro?** Só espere mais: ainda está baixando.

**O Colab diz que a T4 não está disponível?** Acontece na conta gratuita em horário cheio.
Tente mais tarde ou use outra conta Google.

---

Os programas são de terceiros: [Fooocus](https://github.com/lllyasviel/Fooocus) e
[WanGP / Wan2GP](https://github.com/deepbeepmeep/Wan2GP). Aqui só estão os cadernos que os
ligam no Colab de um jeito simples.
