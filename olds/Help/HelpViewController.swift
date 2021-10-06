//
//  HelpViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 05/10/21.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    
    
    //MARK: -View
    lazy var view0:ViewOnboarding =  {
           let view = ViewOnboarding()
           view.setup(titulo: "Legado",
                      text: "Esse é o App Legado! \n\n Aqui você pode registar todas as suas memórias favoritas através de fotos e áudios. \n\n Seja bem-vindo.",
                      imageName: "blueAlbum", imageDescription: "")
           return view
       }()
       
       lazy var view1:ViewOnboarding =  {
           let view = ViewOnboarding()
           view.setup(titulo: "Criando um Álbum",
                      text: "A tela inicial é o local onde ficam todos os seus álbuns, podendo visualizados separados por seus temas ou todos de uma vez. Lá você também conseguirá criar novos albuns clicando em 'Criar Álbum'. \n\n No formulário de criação de álbum você deverá inserir um título e o tema do seu álbum",
                      imageName: "greenAlbum", imageDescription: "")
           return view
       }()
       
       lazy var view2:ViewOnboarding =  {
           let view = ViewOnboarding()
           view.setup(titulo: "Criando uma Página",
                      text: "Depois de criar o Álbum, para adicionar uma página, você clicará em 'Abrir Álbum' e em seguida em Adicionar página. Você poderá Adicionar quantas páginas quiser. \n\n No formulário de crianção da página, você deverá inserir a data de sua memória, além de uma foto e gravar um áudio contando sua memória. \n\n Nessa página solicitaremos a permissão de uso de microfone, cámera e biblioteca de imagens para poder armazenar seu legado em nosso App.",
                      imageName: "redAlbum", imageDescription: "")
           return view
       }()
       
       lazy var view3:ViewOnboarding =  {
           let view = ViewOnboarding()
           view.setup(titulo: "Apagando Álbuns e Páginas",
                      text: "Para apagar tanto seus Álbuns quanto suas Páginas basta pressionar e segurar o album ou página que então irá surgir um botão com a opção 'Apagar'. \n\n Lembre-se, ao confirmar a exclusão de seus Álbuns ou Páginas, eles não poderão ser recuperados.",
                      imageName: "blueAlbum", imageDescription: "")
           return view
       }()
       
       lazy var view4:ViewOnboarding =  {
           let view = ViewOnboarding()
           view.setup(titulo: "Linha do Tempo",
                      text: "Sua Linha do tempo é mais uma forma de acessar suas memórias. Com ela você pode visualiza-las em ordem cronológica.",
                      imageName: "greenAlbum", imageDescription: "")
           return view
       }()
       
       lazy var arrayViews = [view0, view1, view2, view3, view4]

    
    //MARK: -scrollView
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(arrayViews.count), height: view.frame.height)
        
        for i in 0..<arrayViews.count {
            scrollView.addSubview(arrayViews[i])
            arrayViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.delegate = self
        
        return scrollView
    }()
    
    //MARK: -pageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = arrayViews.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ActionColorButton")
        pageControl.isEnabled = true
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    //MARK: -Button
    lazy var butaoNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Próximo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(UIColor(named: "ActionColorButton"), for: .normal)
        button.addTarget(self, action: #selector(addPageContol), for: .touchUpInside)
        
        return button
        
    }()
    
    lazy var butaoPrevious: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Voltar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(UIColor(named: "ActionColorButton"), for: .normal)
        button.addTarget(self, action: #selector(subPageContol), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "BackgroundColorPaper")
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(butaoPrevious)
        view.addSubview(butaoNext)
        setupConstraints()
    }
    
    //MARK: -Constraints
    func setupConstraints(){
        
        //pagecontrol
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let pageControlConstraints:[NSLayoutConstraint] = [
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(pageControlConstraints)
        
        //scrollview
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollViewConstraints:[NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height/3)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        //botoes
        butaoNext.translatesAutoresizingMaskIntoConstraints=false
        let butaoNextConstraints:[NSLayoutConstraint] = [
            butaoNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            butaoNext.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-30)
        ]
        NSLayoutConstraint.activate(butaoNextConstraints)
        
        butaoPrevious.translatesAutoresizingMaskIntoConstraints=false
        let butaoPreviousConstraints:[NSLayoutConstraint] = [
            butaoPrevious.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            butaoPrevious.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30)
        ]
        NSLayoutConstraint.activate(butaoPreviousConstraints)
        
    }

    
    //MARK: -ação de mudar de pagina na pageControl
    @objc
    func pageControlTapHandler(sender: UIPageControl) {
        
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage )
        scrollView.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc
    func addPageContol(){
        if (scrollView.contentOffset.x+view.frame.width < view.frame.width*CGFloat(arrayViews.count)) {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x+view.frame.width, y: 0), animated: false)
            
         
        } else {
            //dismiss
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc
    func subPageContol(){
        butaoNext.setTitle("Próximo", for: .normal)
        if (scrollView.contentOffset.x-view.frame.width>=0){
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x-view.frame.width, y: 0), animated: false)
        }
        
        
    }
    @IBAction func exitAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}



//MARK: -Delegate
extension HelpViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x+view.frame.width == view.frame.width*CGFloat(arrayViews.count)) {
            butaoNext.setTitle("Terminar", for: .normal)
        } else {
            butaoNext.setTitle("Próximo", for: .normal)
        }
        
        if (scrollView.contentOffset.x+view.frame.width == view.frame.width*CGFloat(1)) {
            butaoPrevious.isHidden = true
        } else {
            butaoPrevious.isHidden = false
        }
        
        
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        
    }
}
