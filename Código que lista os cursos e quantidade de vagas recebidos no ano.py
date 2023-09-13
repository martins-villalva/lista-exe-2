#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd

tab = pd.read_excel(r"C:\Users\danie\Pesquisa UFRJ\2020 - ok\ALT02_03 - AnxA -Distribuicao_ de_vagas_de_cursos_expedito.ods",sheet_name='CAAML (ALT-02)',engine='odf')

vagas = [vaga for vaga in tab.drop([0,1,2,3,4,5]).dropna(how='all').iloc[:,6].dropna()] # Seleciona a coluna do G25
cursos = [curso.strip() for curso in tab.drop([0,1,2,3,4,5]).dropna(how='all').iloc[:,0].dropna()] # Seleciona a coluna com os nomes dos cursos

cursos_recebidos = {}
# Itera sobre as vagas e os cursos
for vaga, curso in zip(vagas, cursos):
    if str(vaga).isnumeric():  # Verifica se é um número
        if curso in cursos_recebidos:  # Verifica se o curso já está no dicionário
            cursos_recebidos[curso] += int(vaga)  # Atualiza o número de vagas
        else:
            cursos_recebidos[curso] = int(vaga)

cursos_recebidos


# In[ ]:




