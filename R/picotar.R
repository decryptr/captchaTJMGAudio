#' Quebra onda em letras
#'
#' Esta função faz as seguintes tarefas: 1. limpa o som, substituindo por zero
#' todas as frequências com valores absolutos menores que 2000. 2. Retira os
#' zeros iniciais e os zeros finais. 3. Identifica todos os intervalos contíguos
#' de zeros e seleciona os 4 maiores intervalos. Os cortes são definidos como o
#' ponto médio de cada intervalo contíguo de zeros.
#'
#' @param onda vetor de frequências retornado por \code{\link{ler_audio}}.
#'
#' @export
quebrar_letras <- function(onda) {
  d_clean <- tibble::tibble(som = onda,
                            tempo = 1:length(onda)) %>%
    dplyr::mutate(som = ifelse(abs(som) < 2000, 0, som),
                  abs_som = abs(som),
                  acu = cumsum(abs_som)) %>%
    dplyr::arrange(dplyr::desc(tempo)) %>%
    dplyr::mutate(revacu = cumsum(abs_som)) %>%
    dplyr::arrange(tempo) %>%
    dplyr::filter(acu > 0, revacu > 0)
  cortes <- d_clean %>%
    dplyr::filter(som == 0) %>%
    dplyr::mutate(lg = dplyr::lag(tempo), trocou = (tempo != lg + 1)) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(n = cumsum(trocou) + 1) %>%
    dplyr::group_by(n) %>%
    dplyr::summarise(xi = min(tempo), xf = max(tempo), r = xf - xi) %>%
    dplyr::arrange(dplyr::desc(r)) %>%
    head(4) %>%
    dplyr::mutate(corte = round((xf + xi) / 2)) %>%
    with(corte) %>%
    sort()
  d_clean %>%
    dplyr::mutate(letra = cut(tempo, c(0, cortes, max(tempo))),
                  letra = as.character(as.numeric(letra)))
}

#' Monta tabela de letras e soma de frequências
#'
#' Essa função usa \code{\link{quebrar_letras}} para quebrar as letras do áudio.
#' Depois, agrupa por letra e soma todas as frequências. Como não há ruído, a
#' soma das frequências identifica unicamente o número e, portanto, basta
#' tabelar as somas, associando cada soma a um número manualmente.
#'
#' @param arq_aud caminho/do/audio/do/captcha.wav ou objeto do tipo response.
#'
#' @export
#'
#' @examples
#' arq_aud <- system.file('audio.wav', package = 'captchaTJMGAudio')
#' tabelar_letras(arq_aud)
tabelar_letras <- function(arq_aud) {
  onda <- ler_audio(arq_aud)
  # desenhar_corte(onda)
  onda %>%
    quebrar_letras() %>%
    dplyr::group_by(letra) %>%
    dplyr::summarise(soma = sum(som))
}
