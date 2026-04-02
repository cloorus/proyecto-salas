import React from 'react';
import CardEngineStats from '../../components/Cards/CardEngineStats';
import CardCountryStats from '../../components/Cards/CardCountryStats';
import CardPersonStats from '../../components/Cards/CardPersonStats';
import CardEngineTypeStats from '../../components/Cards/CardEngineTypeStats';
import CardActivationStats from '../../components/Cards/CardActivationStats';

const Home: React.FC = () => {
  return (
    <>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5">
        <CardPersonStats/>
        <CardEngineStats/>
        <CardEngineTypeStats/>
        <CardCountryStats/>
       </div>
      <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5">
        <CardActivationStats/>
      </div>
    </>
  );
};

export default Home;
