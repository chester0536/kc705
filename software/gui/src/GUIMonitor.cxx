#include "GUIMonitor.hh"
#include <iostream>


using namespace std::chrono_literals;

GUIMonitor::GUIMonitor(const JadeOption& options):
  JadeMonitor(options),
  m_opt(options),
  m_ev_get(0),
  m_ev_num(0),
  m_nx(16),
  m_ny(48),
  m_col(0),
  m_row(0)
{
  m_ev_get = m_opt.GetIntValue("PRINT_EVENT_N");
  m_curr_time = m_opt.GetStringValue("CURRENT_TIME");
  m_col = m_opt.GetIntValue("COLUMN");
  m_row = m_opt.GetIntValue("ROW");

  m_last_frame_adc.resize(m_nx*m_ny,0);
  m_sum_frame_adc.resize(m_nx*m_ny,0);

  m_u_adcFrame = std::make_shared<adcFrame>();

  m_u_adcFrame->cds_frame_adc.resize(m_nx*m_ny,0);
  m_u_adcFrame->mean_frame_adc.resize(m_nx*m_ny,0);
  m_u_adcFrame->rms_frame_adc.resize(m_nx*m_ny,0);
  
  m_u_adcFrame->hist_mean = std::make_shared<TH1D>(Form("mean_%s",m_curr_time),"mean",4000,-2000,2000);
  m_u_adcFrame->hist_rms = std::make_shared<TH1D>(Form("rms_%s",m_curr_time),"rms",4000,-2000,2000);
 
  m_adcFrame = m_u_adcFrame; 
}

void GUIMonitor::Monitor(JadeDataFrameSP df)
{
  if( m_ev_get!=0 && (m_ev_num++) % m_ev_get == 0 ){
  std::unique_lock<std::mutex> lk_in(m_mx_set);
  m_df = df; 
  lk_in.unlock();

  auto adc_value = m_df->GetFrameData();

  if(m_ev_num==1) m_last_frame_adc.assign(adc_value.begin(), adc_value.end()); 

  std::transform(adc_value.begin(), adc_value.end(), m_last_frame_adc.begin(), m_u_adcFrame->cds_frame_adc.begin(), std::minus<int16_t>()); 

  m_last_frame_adc.swap(adc_value); 

  std::transform(m_sum_frame_adc.begin(), m_sum_frame_adc.end(), m_u_adcFrame->cds_frame_adc.begin(), m_sum_frame_adc.begin(), std::plus<int16_t>()); 

  std::transform(m_sum_frame_adc.begin(), m_sum_frame_adc.end(), m_u_adcFrame->mean_frame_adc.begin(), std::bind2nd(std::divides<int16_t>(),m_ev_num)); 

  std::transform(m_mean_frame_adc.begin(), m_mean_frame_adc.end(), m_u_adcFrame->cds_frame_adc.begin(), m_u_adcFrame->rms_frame_adc.begin(), std::minus<int16_t>()); 
 
  m_u_adcFrame->hist_mean->Fill(m_u_adcFrame->mean_frame_adc.at(m_row+m_col*m_ny));
  m_u_adcFrame->hist_rms->Fill(m_u_adcFrame->rms_frame_adc.at(m_row+m_col*m_ny));

  std::unique_lock<std::mutex> lk_out(m_mx_get);
  m_adcFrame = m_u_adcFrame; 
  lk_out.unlock();
  }
}

QCPColorMapData* GUIMonitor::GetADCMap()
{
  std::unique_lock<std::mutex> lk_in(m_mx_get);
  auto u_adcFrame = m_adcFrame; 
  lk_in.unlock();

  m_adc_map = new QCPColorMapData(m_ny, m_nx, QCPRange(0,m_ny), QCPRange(0,m_nx));

  for (size_t iy = 0; iy < m_ny; iy++){
    for (size_t ix = 0; ix < m_nx; ix++)
    {
      m_adc_map->setCell(iy, ix, u_adcFrame->cds_frame_adc.at(iy+m_ny*ix));
      //std::cout << u_adcFrame->cds_frame_adc.at(iy+m_ny*ix) << " ";
    }
    //std::cout << "\n";
  }
  //std::cout << "\nend send" << std::endl;

  return m_adc_map;
}

QVector<QCPGraphData> GUIMonitor::GetPedestal(int col, int row){

  std::cout << "Get Pedestal..."<<std::endl;
  
  std::unique_lock<std::mutex> lk_in(m_mx_get);
  auto u_adcFrame = m_adcFrame; 
  lk_in.unlock();
  
  QCPGraphData point;

  for(int iBin=0; iBin<u_adcFrame->hist_mean->GetNbinsX(); iBin++){
    point.key = u_adcFrame->hist_mean->GetXaxis()->GetBinCenter(iBin); 
    point.value = u_adcFrame->hist_mean->GetBinContent(iBin);
    m_pedestal.append(point);
  }
  return m_pedestal;
}

QVector<QCPGraphData> GUIMonitor::GetNoise(int col, int row){

  std::cout << "Get Noise..."<<std::endl;

  std::unique_lock<std::mutex> lk_in(m_mx_get);
  auto u_adcFrame = m_adcFrame; 
  lk_in.unlock();
  
  QCPGraphData point;

  for(int iBin=0; iBin<u_adcFrame->hist_rms->GetNbinsX(); iBin++){
    point.key = u_adcFrame->hist_rms->GetXaxis()->GetBinCenter(iBin); 
    point.value = u_adcFrame->hist_rms->GetBinContent(iBin);
    m_noise.append(point);
  }

  return m_noise;
}

void GUIMonitor::Reset(){
  m_u_adcFrame->hist_mean->Reset();
  m_u_adcFrame->hist_rms->Reset();
}
