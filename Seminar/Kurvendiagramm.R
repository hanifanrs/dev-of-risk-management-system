install.packages(('ggplot2'))
library(ggplot2)

ggplot(data=portfolio, aes(x=Datum))+
  geom_line(aes(y=Wert, color='1'), linetype=1, size=2)+
  geom_point(aes(y=Wert, color='1'), size=4)+
  geom_line(aes(y=Value_at_risk, color='2'), linetype=1, size=2)+
  geom_point(aes(y=Value_at_risk, color='2'), size=4)+
  labs(y='Prozentuale Veränderung', title='Kurvendiagramm')+
  theme(plot.title= element_text(hjust=0.5))+
  scale_color_manual(values = c('darkgreen', 'steelblue'), name='Legende:', labels=c('Wert des Portfolios', 'VaR'))+
  theme(legend.position='bottom')
  

